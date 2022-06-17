# MCP
 oc get node -o custom-columns=NAME:metadata.name,STATE:metadata.annotations.machineconfiguration\\.openshift\\.io/state,DESIRED:metadata.annotations.machineconfiguration\\.openshift\\.io/desiredConfig,CURRENT:metadata.annotations.machineconfiguration\\.openshift\\.io/currentConfig,REASON:metadata.annotations.machineconfiguration\\.openshift\\.io/reason


