import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;

namespace KeyVault;

interface HsmSecurityDomain {
  /**
   * Retrieves the Security Domain download operation status
   */
  @route("/securitydomain/download/pending")
  @get
  downloadPending is Azure.Core.Foundations.Operation<
    {},
    SecurityDomainOperationStatus
  >;

  /**
   * Retrieves the Security Domain from the managed HSM. Calling this endpoint can
   * be used to activate a provisioned managed HSM resource.
   */
  @pollingOperation(HsmSecurityDomain.downloadPending)
  @route("/securitydomain/download")
  @post
  download is Azure.Core.Foundations.LongRunningOperation<
    {
      /**
       * The Security Domain download operation requires customer to provide N certificates (minimum 3 and maximum 10)
       * containing a public key in JWK format.
       */
      @body
      certificateInfoObject: CertificateInfoObject;
    },
    {
      @statusCode _: 202;

      /**
       * The URI to poll for completion status.
       */
      @pollingLocation
      @header("Azure-AsyncOperation")
      azureAsyncOperation?: string;

      /**
       * The recommended number of seconds to wait before calling the URI specified in
       * Azure-AsyncOperation.
       */
      @header("Retry-After") retryAfter?: int32;

      /**
       * The response contains the Security Domain that is being confirmed.
       */
      @body response: SecurityDomainObject;
    }
  >;

  /**
   * Retrieve Security Domain transfer key
   */
  @route("/securitydomain/upload")
  @get
  transferKey is Azure.Core.Foundations.Operation<{}, TransferKey>;

  /**
   * Restore the provided Security Domain.
   */
  @route("/securitydomain/upload")
  @post
  upload is Azure.Core.Foundations.Operation<
    SecurityDomainObject,
    SecurityDomainOperationStatus | void
  >;

  /**
   * Get Security Domain upload operation status
   */
  @route("/securitydomain/upload/pending")
  @get
  uploadPending is Azure.Core.Foundations.Operation<
    {},
    SecurityDomainOperationStatus
  >;
}
