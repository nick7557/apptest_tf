node{
    def repo_url = "852841908877.dkr.ecr.us-west-1.amazonaws.com/ecr_docker_repository"
    def version = "latest"

    //operation = [create| update]
    def operation = "create"

    stage('SCM Checkout'){
    checkout(scm)
    }

    def mvnHome = tool name: 'M3', type: 'maven'
    stage('Test'){
         sh "${mvnHome}/bin/mvn test"
    }

    stage('Package'){
         sh "${mvnHome}/bin/mvn package"
    }

    stage('Build'){
    sh "\$(aws ecr get-login --region us-west-1)"
    #sh "\$(aws ecr get-login --no-include-email --region us-west-1)"
    sh "docker build -t ecr_docker_repository ."
    sh "docker tag ecr_docker_repository:latest ${repo_url}:${version}"
    sh "docker push ${repo_url}:${version}"
    }

    stage('deploy'){
    sh "chmod 700 td-tomcat.template"
    sh "chmod 700 service-update-tomcat.json"
    sh "chmod 700 service-create-tomcat.json"
    sh "chmod 700 deploy.sh"
    sh "./deploy.sh ${repo_url}:${version} ${operation}"
    }
}
