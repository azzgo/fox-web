apiVersion: apps/v1
kind: Deployment
metadata:
  name: fox-web
  labels:
    app: fox-web
spec:
  replicas: 2
  selector:
    matchLabels:
      app: fox-web
  template:
    metadata:
      labels:
        app: fox-web
    spec:
      initContainers:
      - name: assets
        image: {{DOCKER_REGISTRY_HOST}}/fox-web-assets:latest
        imagePullSecrets:
        - name: docker-registry-login
        volumeMounts:
        - mountPath: /assets
          name: assets
        command: ["sh", "-c", "cp -r /tmp/assets/* /assets"]
      containers:
      - name: nginx
        image: nginx:1.17.7
        volumeMounts:
        - mountPath: /usr/share/nginx/html
          name: assets
        ports:
          - containerPort: 80
      volumes:
      - name: assets
        emptyDir: {}
        
    

