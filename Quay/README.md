# 2 Quay 1 Quay principal and 1 Quay in mirror mode
- Add dns entry for both Quay
- oc edit image.config.openshift.io/cluster or

Quay principal: example-registry-quay-quay-registry.apps.ocp2.lab.seeweb
Quay mirror:    quay-quay-registry.apps.ocp3.lab.seeweb


```
 spec:
   registrySources:
     containerRuntimeSearchRegistries: 
     - example-registry-quay-quay-registry.apps.ocp2.lab.seeweb
     - quay-quay-registry.apps.ocp3.lab.seeweb
```

Configure both quay with:

Organization name: testorg
Reponame:          demorepo (public on both quay instances)

demorepo configured in mirroring mode on quay-quay-registry.apps.ocp3.lab.seeweb

Test 1:
- Deploy an application on OcpHub using an image NOT present on Quay2 (mirrored)
- the image name should be "testorg/demorepo:latest"
- Upload the image on Quay1
- Wait for mirroring Quay2 
- Is the application running on OcpHub?

- On OcpHub can not deploy testorg/demorepo:latest from webconsole and cli
- Login to Quay1:
    - podman login -u valeidm example-registry-quay-quay-registry.apps.ocp2.lab.seeweb
      Login Succeeded!
    
oc run test --image=testorg/demorepo:latest