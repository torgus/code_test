**Code Test Job Description**

**Objective:**

Deploy a Rust "Hello World" application using Docker in a Kubernetes
cluster managed by Minikube. Optionally Integrate vulnerability scanning
or autoscaling (not mandatory).

**Requirements:**

1.  **Setup Minikube Cluster**:

    Minikube Installation depends of the platform deployed, in my case, I use MacOs, so I'll use Homebrew for the installation.

    `brew install minikube`

    From this point we will continue the exercise using terraform + helm.

    In the folder `terraform/` you will find the terraform code used for the setup and deploy of the cluster. We will focus now on the different files of the folder:

    - init.tf: here you will find all the provider definition, , as i dont want to reinvent the wheel, i will use the minikube provider for terraform courtesy of "scott-the-programmer" ( https://registry.terraform.io/providers/scott-the-programmer/minikube/), i also install the helm provider.
    - main.tf: here we will finde the basic kubernetes cluster setup, and the optional controllers, addons and software we will use in our cluster.
    - deploy.tf: here we will find the helm release installation.



    In the folder `helm/` we will find the code of the helm release used to deploy the app, with their default values. This charts implements:
      - A deployment with 1 replica by default
      - A service to point the replicas of the deployment
      - An Ingress to expose the service outside the cluster ( Needs nginx ingress controller installed by minikube addons )
      - A ServiceAccount to run the pods with.
      - A Horizontal Pod Autoscales to scale up the deployment.
     I used the default skeleton created by `helm create <chart-name>`

    In the folder `docker/` we will find the code of how to build the rust helloworld application. For this part, considering i dont have experience with rust, i used the https://github.com/jaya-p/rustwebservice repo to build the image, the kubernetes part i prefer to use helm , as i consider is better solution for code maintainability.


    In the root folder we will find the .tfvars file for our environment.



2.  **Application Deployment**:

    - To deploy the propossed solution, the following steps are necessary:
     1. Build the Docker Image. `cd docker; docker build -t rustwebservice . -f Multistage.Dockerfile`
     2. Upload the result of the build to your prefered registry, if you dont want to do it, there is an image upload to `torgus/rustwebservice:latest` on dockerhub
     3. apply terraform with: `terraform init; terraform apply --var-file ../default.tfvars` , or if you want to deploy in a different workspace(i.e different environments), create it with `terraform workspace new <workspace name>` and then `terraform apply --var-file ../<workspace>.tfvars` (empty file accepted). You can put your helm values for the helm release under `helm_values/<workspace>/values.yaml` (empty file accepted)
     4. wait to terraform to complete.

      In my particular case, i use minikube in macos with docker driver, so i need to open a tunnel from macosx to docker VM, i do it with `minikube profile <name of your cluster defined on terraform variables>; minikube tunnel`
      The default ( can be overrided by values) host for the rust app is rustk8s.local, you can test it with ` curl --resolve "rustk8s.local:80:127.0.0.1" -i http://rustk8s.local/api/v1/helloworld`. You should obtain something like:
      ```
      01:17 $ curl --resolve "rustk8s.local:80:127.0.0.1" -i http://rustk8s.local/api/v1/helloworld
        HTTP/1.1 200 OK
        Date: Sat, 25 May 2024 23:31:33 GMT
        Content-Length: 11
        Connection: keep-alive

        Hello World✔ ~
      ```


2.  **Autoscaling (optional)**:

    - The helm chart used is the default one created by `helm create <chart-name>`, this default chart implements hpa if you configure it on the values. To achieve it, you need to set limit/requests on the deployment, and install metrics-server addon to get cpu/memory metrics. 
    - In the exercise, the pods are limited to 100m ( 0,1 CPU) and 128M on the default values, and the HPA is configured to scale up on 10% cpu use.
    - To test it, just laungh a jmeter with the config file included on this repo ( rustk8s.jmx)
    
3.  **Vulnerability Scanning with SonarQube (optional)**:

    - Unfortunately , i dont have a public sonarqube instance to integrate with it, but i have been taking a look of the official documentation( https://docs.sonarsource.com/sonarqube/latest/devops-platform-integration/github-integration/introduction/) , if you can provide me a token and a sonarqube public URL, I will be happy to integrate it and push it to this repo.