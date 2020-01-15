pipeline {
  agent {
    kubernetes {
      yamlFile './deployments/nodejs.pod.slave.yaml'
    }
  }

  environment {
    DOCKER_LOGIN_CRT = credentials('6a4e2e31-c411-4abd-8d1f-61028ffb5dee')
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
          sh 'docker loginharbor-harbor-registry:8080 -u ${DOCKER_LOGIN_CRT_USR} -p ${DOCKER_LOGIN_CRT_PSW}'
          sh 'docker build -f Dockerfile -tharbor-harbor-registry:8080/fox-web-assets:${GIT_COMMIT} .'
          sh 'docker tagharbor-harbor-registry:8080/fox-web-assets:${GIT_COMMIT}harbor-harbor-registry:8080/fox-web-assets:latest'
          sh 'docker pushharbor-harbor-registry:8080/fox-web-assets:${GIT_COMMIT}'
          sh 'docker pushharbor-harbor-registry:8080/fox-web-assets:latest'
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
