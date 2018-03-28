public with sharing class ctrlEncrypt {
private static final blob pkey= blob.valueof('tesii3ddddcomusa');
private string mValue;

	public string val {
		SET {
			mValue=value;
		}
		GET {
			return EncodingUtil.urlEncode(encrypt(mValue),'UTF-8');
		}
	}

	//s: string to encrypt; returns: encrypted base64 string
	public static string encrypt(string s) {
		return EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES128', pkey, Blob.valueOf(s)));
	}
	//s: encrypted base64 string; returns decrypted value
	public static string decrypt(string s) {
		return Crypto.decryptWithManagedIV('AES128', pkey, EncodingUtil.base64Decode(s)).toString();
	}
}