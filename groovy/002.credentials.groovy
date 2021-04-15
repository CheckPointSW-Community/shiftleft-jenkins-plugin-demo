import com.cloudbees.plugins.credentials.impl.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.domains.*

def env = System.getenv()

Credentials c = (Credentials) new UsernamePasswordCredentialsImpl(CredentialsScope.GLOBAL,"cloudguard-credentials",
                                                                  "CloudGuard Shiftleft Credentials",
                                                                  env.CHKP_CLOUDGUARD_ID,
                                                                  env.CHKP_CLOUDGUARD_SECRET)

SystemCredentialsProvider.getInstance().getStore().addCredentials(Domain.global(), c)
