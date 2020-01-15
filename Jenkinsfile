pipeline {
  agent {
    kubernetes {
      yamlFile './deployments/nodejs.pod.slave.yaml'
    }
  }

  stages {
    stage('构建前端工程') {
      steps {
        container('nodejs') {
          sh 'yarn install --prod'
          sh 'yarn build'
        }
      }
    }

    stage('构建镜像并上传仓库') {
      steps {
        container('docker') {
          sh 'docker build -f Dockerfile.k8s -t docker-registry:5000/fox-web-assets:${GIT_COMMIT} .'
          sh 'docker tag docker-registry:5000/fox-web-assets:${GIT_COMMIT} docker-registry:5000/fox-web-assets:latest'
          sh 'docker push docker-registry:5000/fox-web-assets:${GIT_COMMIT}'
          sh 'docker push docker-registry:5000/fox-web-assets:latest'
        }
      }
    }

    stage('发布到开发环境') {
      steps {
        container('kubectl') {
          sh 'kubectl apply -o name --force -f ./deployments/web.service.yml'
          sh '''
          DEPLOYMENT_NAME=$(kubectl apply -o name --force -f ./deployments/web.deployment.yml)
          kubectl rollout status $DEPLOYMENT_NAME
          '''
        }
      }
    }
  }
}
