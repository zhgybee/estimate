package com.estimate.utils;

import java.io.File;
import net.lingala.zip4j.core.ZipFile;
import net.lingala.zip4j.exception.ZipException;
import net.lingala.zip4j.model.ZipParameters;
import net.lingala.zip4j.util.Zip4jConstants;

public class ZipUtils 
{
	public static void compress(File source, File target) throws ZipException
	{
		ZipFile zipFile = new ZipFile(target);
		
		ZipParameters parameters = new ZipParameters();
        parameters.setCompressionMethod(Zip4jConstants.COMP_DEFLATE);
        parameters.setCompressionLevel(Zip4jConstants.DEFLATE_LEVEL_NORMAL); 
        parameters.setEncryptFiles(true);
        parameters.setEncryptionMethod(Zip4jConstants.ENC_METHOD_AES);
        parameters.setAesKeyStrength(Zip4jConstants.AES_STRENGTH_256);
        parameters.setPassword("NEST%^&*"); 
        
        zipFile.addFolder(source, parameters); 
	}
	
	public static void decompress(File source, File target) throws ZipException
	{
        ZipFile zipFile = new ZipFile(source);
        if (zipFile.isEncrypted()) 
        {
        	zipFile.setPassword("NEST%^&*".toCharArray());
        }
        zipFile.extractAll(target.getAbsolutePath());
	}
}
