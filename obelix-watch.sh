#!/usr/bin/env sh

kubectl apply -f - << EOT
apiVersion: batch/v1
kind: Job
metadata:
  namespace: ${NAMESPACE}
  name: obelix-${NODE}
spec:
  template:
    spec:
      nodeName: ${NODE}
      containers:
        - name: obelix
          image: busybox
          command: ["ls", "-alR", "/"]
          volumeMounts:
            - mountPath: /products
              name: products
            - mountPath: /deploy
              name: deploy
      volumes:
        - hostPath:
            path: /products
            type: Directory
          name: products
        - hostPath:
            path: /deploy
            type: Directory
          name: deploy
EOT
