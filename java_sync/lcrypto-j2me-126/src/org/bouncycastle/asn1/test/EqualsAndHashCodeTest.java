package org.bouncycastle.asn1.test;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.util.Date;

import org.bouncycastle.util.test.Test;
import org.bouncycastle.util.test.TestResult;
import org.bouncycastle.util.test.SimpleTestResult;
import org.bouncycastle.asn1.ASN1InputStream;
import org.bouncycastle.asn1.ASN1OutputStream;
import org.bouncycastle.asn1.BERConstructedOctetString;
import org.bouncycastle.asn1.BERSequence;
import org.bouncycastle.asn1.BERSet;
import org.bouncycastle.asn1.BERTaggedObject;
import org.bouncycastle.asn1.DERApplicationSpecific;
import org.bouncycastle.asn1.DERBMPString;
import org.bouncycastle.asn1.DERBitString;
import org.bouncycastle.asn1.DERBoolean;
import org.bouncycastle.asn1.DEREnumerated;
import org.bouncycastle.asn1.DERGeneralString;
import org.bouncycastle.asn1.DERGeneralizedTime;
import org.bouncycastle.asn1.DERIA5String;
import org.bouncycastle.asn1.DERInteger;
import org.bouncycastle.asn1.DERNull;
import org.bouncycastle.asn1.DERNumericString;
import org.bouncycastle.asn1.DERObject;
import org.bouncycastle.asn1.DERObjectIdentifier;
import org.bouncycastle.asn1.DEROctetString;
import org.bouncycastle.asn1.DERPrintableString;
import org.bouncycastle.asn1.DERSequence;
import org.bouncycastle.asn1.DERSet;
import org.bouncycastle.asn1.DERT61String;
import org.bouncycastle.asn1.DERTaggedObject;
import org.bouncycastle.asn1.DERTags;
import org.bouncycastle.asn1.DERUTCTime;
import org.bouncycastle.asn1.DERUTF8String;
import org.bouncycastle.asn1.DERUniversalString;
import org.bouncycastle.asn1.DERUnknownTag;
import org.bouncycastle.asn1.DERVisibleString;

public class EqualsAndHashCodeTest
    implements Test
{
    public TestResult perform()
    {
        byte[]	data = { 0, 1, 0, 1, 0, 0, 1 };
        
        DERObject    values[] = {
                new BERConstructedOctetString(data),
                new BERSequence(new DERPrintableString("hello world")),
                new BERSet(new DERPrintableString("hello world")),
                new BERTaggedObject(0, new DERPrintableString("hello world")),
                new DERApplicationSpecific(0 | DERTags.APPLICATION, data),
                new DERBitString(data),
                new DERBMPString("hello world"),
                new DERBoolean(true),
                new DERBoolean(false),
                new DEREnumerated(100),
                new DERGeneralizedTime(new Date()),
                new DERGeneralString("hello world"),
                new DERIA5String("hello"),
                new DERInteger(1000),
                new DERNull(),
                new DERNumericString("123456"),
                new DERObjectIdentifier("1.1.1.10000.1"),
                new DEROctetString(data),
                new DERPrintableString("hello world"),
                new DERSequence(new DERPrintableString("hello world")),
                new DERSet(new DERPrintableString("hello world")),
                new DERT61String("hello world"),
                new DERTaggedObject(0, new DERPrintableString("hello world")),
                new DERUniversalString(data),
                new DERUnknownTag(0xff & (~(DERTags.TAGGED | DERTags.APPLICATION)), data),
                new DERUTCTime(new Date()),
                new DERUTF8String("hello world"),
                new DERVisibleString("hello world")
            };
        
        try
        {
            ByteArrayOutputStream   bOut = new ByteArrayOutputStream();
            ASN1OutputStream        aOut = new ASN1OutputStream(bOut);
            
            for (int i = 0; i != values.length; i++)
            {
                aOut.writeObject(values[i]);
            }
            
            DERObject[] readValues = new DERObject[values.length];
            
            ByteArrayInputStream    bIn = new ByteArrayInputStream(bOut.toByteArray());
            ASN1InputStream         aIn = new ASN1InputStream(bIn);
            
            for (int i = 0; i != values.length; i++)
            {
                DERObject   o = aIn.readObject();
                if (!o.equals(values[i]))
                {
                    return new SimpleTestResult(false, getName() + ": Failed equality test for " + o);
                }
                
                if (o.hashCode() != values[i].hashCode())
                {
                    return new SimpleTestResult(false, getName() + ": Failed hashCode test for " + o);
                }
            }
        }
        catch (Exception e)
        {
            return new SimpleTestResult(false, getName() + ": Failed - exception " + e.toString(), e);
        }
        
        return new SimpleTestResult(true, getName() + ": Okay");
    }

    public String getName()
    {
        return "EqualsAndHashCode";
    }

    public static void main(
        String[] args)
    {
        EqualsAndHashCodeTest    test = new EqualsAndHashCodeTest();
        TestResult      result = test.perform();

        System.out.println(result);
    }
}
