pipeline {
  agent {
    kubernetes {
      yamlFile './deployments/nodejs.pod.slave.yaml'
    }
  }

  environment {
    DOCKER_REGISTRY_HOST="docker-registry.192-168-33-10.nip.io"
    DOCKER_REGISTRY_LOGIN=credentials("docker-registry-login")
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
          sh 'docker build -f Dockerfile -t ${DOCKER_REGISTRY_HOST}/fox-web-assets:${GIT_COMMIT} .'
          sh 'docker tag ${DOCKER_REGISTRY_HOST}/fox-web-assets:${GIT_COMMIT} ${DOCKER_REGISTRY_HOST}/fox-web-assets:latest'
          sh 'docker login ${DOCKER_REGISTRY_HOST} -u ${DOCKER_REGISTRY_LOGIN_USR} -p ${DOCKER_REGISTRY_LOGIN_PSW}'
          sh 'docker push ${DOCKER_REGISTRY_HOST}/fox-web-assets:${GIT_COMMIT}'
          sh 'docker push ${DOCKER_REGISTRY_HOST}/fox-web-assets:latest'
        }
      }
    }

    stage('发布到开发环境') {
      steps {
        container('kubectl') {
          sh 'kubectl apply -o name --force -f ./deployments/dev/service.yaml'
          sh '''
          DEPLOYMENT_NAME=$(kubectl apply -o name --force -f ./deployments/dev/deployment.yaml)
          kubectl rollout status $DEPLOYMENT_NAME
          '''.stripIndent()
        }
      }
    }
  }
}
