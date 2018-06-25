// Usage:
//     javac TestUCE.java
//     java -cp . TestUCE

import java.io.PrintStream;
import javax.crypto.Cipher;

public class TestUCE
{
    public static void main(String[] paramArrayOfString)
        throws Exception
    {
        boolean bool = Cipher.getMaxAllowedKeyLength("RC5") >= 256;
        System.out.println("Unlimited cryptography enabled: " + bool);
    }
}
