job('shiftleft-code-scan-demo') {
  scm {
    git {
      remote {
        name('origin')
        url('https://gitlab.com/itamar.lavender/demo-app.git')
      }
    branch('master')
      extensions {
        cleanBeforeCheckout()
        relativeTargetDirectory('demo-app')
      }
    }
  }
  steps {
    bladeBuilder {
      blades {
        codeScan {
          source('demo-app')
          credentialsId('cloudguard-credentials')
          exclude("")
          noCache(true)
		  noProxy(true)
          noBlame(false)
          ruleset("")
          severityLevel("")
          severityThreshold(null)
          ignoreFailure(false)
          onFailureCmd("")
        }
      }
    }
  }
}
