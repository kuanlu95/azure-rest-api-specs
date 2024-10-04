import "@typespec/rest";
import "@typespec/http";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace KeyVault;

/**
 * Operation status.
 */
union OperationStatus {
  string,

  /** The operation succeeded. */
  Success: "Success",

  /** The operation is in progress. */
  InProgress: "InProgress",

  /** The operation failed. */
  Failed: "Failed",
}

/**
 * The Security Domain operation status.
 */
model SecurityDomainOperationStatus {
  /**
   * Operation status.
   */
  status?: OperationStatus;

  /**
   * Details of the operation status.
   */
  @encodedName("application/json", "status_details")
  statusDetails?: string;
}

/**
 * The key vault error exception.
 */
@error
model KeyVaultError {
  /**
   * The key vault server error.
   */
  @visibility("read")
  error?: Error;
}

/**
 * The key vault server error.
 */
model Error {
  /**
   * The error code.
   */
  @visibility("read")
  code?: string;

  /**
   * The error message.
   */
  @visibility("read")
  message?: string;

  /**
   * The key vault server error.
   */
  @visibility("read")
  @encodedName("application/json", "innererror")
  innerError?: Error;
}

/**
 * The Security Domain download operation requires customer to provide N certificates (minimum 3 and maximum 10)
 * containing a public key in JWK format.
 */
model CertificateInfoObject {
  /**
   * Certificates needed from customer.
   */
  certificates: SecurityDomainJsonWebKey[];

  /**
   * Customer to specify the number of certificates (minimum 2 and maximum 10) to restore Security Domain.
   */
  @maxValue(10)
  @minValue(2) // TODO: resolve whether this minimum should be 2 or 3 (see class description vs. property description)
  required?: int32 = 2;
}

/**
 * A JSON Web Key (JWK) for use in a security domain operation.
 */
model SecurityDomainJsonWebKey {
  /**
   * Key identifier.
   */
  kid: string;

  /**
   * JsonWebKey Key Type (kty), as defined in
   * https://tools.ietf.org/html/draft-ietf-jose-json-web-algorithms-40. For
   * Security Domain this value must be RSA.
   */
  kty: string;

  /**
   * Set of permitted key operations for the key.
   */
  @encodedName("application/json", "key_ops")
  keyOps: string[];

  /**
   * RSA modulus.
   */
  n: string;

  /**
   * RSA public exponent.
   */
  e: string;

  /**
   * X509 certificate chain parameter.
   */
  @encodedName("application/json", "x5c")
  x5C: string[];

  /**
   * Public Key Use Parameter. This is optional and if present must be enc.
   */
  use?: string;

  /**
   * X509 certificate SHA1 thumbprint. This is optional.
   */
  @encodedName("application/json", "x5t")
  x5T?: string;

  /**
   * X509 certificate SHA256 thumbprint.
   */
  @encodedName("application/json", "x5t#S256")
  x5tS256: string;

  /**
   * Algorithm intended for use with the key.
   */
  alg: string;
}

/**
 * The Security Domain.
 */
model SecurityDomainObject {
  /**
   * The Security Domain.
   */
  value: string;
}

/**
 * Security Domain transfer key.
 */
model TransferKey {
  /**
   * Specifies the format of the transfer key.
   */
  @encodedName("application/json", "key_format")
  keyFormat?: string = "jwk";

  /**
   * Specifies the transfer key in JWK format.
   */
  @encodedName("application/json", "transfer_key")
  transferKeyJwk: SecurityDomainJsonWebKey;
}

/**
 * The object attributes managed by the KeyVault service.
 */
model Attributes {
  /**
   * Determines whether the object is enabled.
   */
  enabled?: boolean;

  /**
   * Not before date in UTC.
   */
  @encodedName("application/json", "nbf")
  @encode("unixTimestamp", int32)
  notBefore?: utcDateTime;

  /**
   * Expiry date in UTC.
   */
  @encodedName("application/json", "exp")
  @encode("unixTimestamp", int32)
  expires?: utcDateTime;

  /**
   * Creation time in UTC.
   */
  @visibility("read")
  @encode("unixTimestamp", int32)
  created?: utcDateTime;

  /**
   * Last updated time in UTC.
   */
  @visibility("read")
  @encode("unixTimestamp", int32)
  updated?: utcDateTime;
}
