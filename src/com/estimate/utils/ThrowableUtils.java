package com.estimate.utils;

public class ThrowableUtils
{
	 public static Throwable getThrowable(Throwable throwable)
	 {
		 Throwable next = throwable.getCause();  
		 if (next == null) 
		 {  
			 return throwable;
		 } 
		 else 
		 {  
			 return getThrowable(next);
		 }
	 }
}
