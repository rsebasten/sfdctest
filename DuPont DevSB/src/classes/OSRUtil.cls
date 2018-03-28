public class OSRUtil {

private static boolean run = true;
private static boolean run1 = true;
private static boolean run2 = true;
private static boolean run3 = true;

 public static boolean runOnce(){
 if(run){
 run=false;
 return true;
 }
 else{return run;}
 }
public static boolean run1Once(){
 if(run1){
 run1=false;
 return true;
 }
 else{return run1;}
 }
 public static boolean run2Once(){
 if(run2){
 run2=false;
 return true;
 }
 else{return run2;}
 }
 public static boolean run3Once(){
 if(run3){
 run3=false;
 return true;
 }
 else{return run3;}
 }

 private static testmethod void testOSRUtil(){
 System.assert(OSRUtil.runOnce(), 'Recursion check failed. Please review OSRUtil recursion logic');
 System.assert(!OSRUtil.runOnce(), 'Recursion check failed. Please review OSRUtil recursion logic');
 System.assert(OSRUtil.run1Once(), 'Recursion check failed. Please review OSRUtil recursion logic');
 System.assert(!OSRUtil.run1Once(), 'Recursion check failed. Please review OSRUtil recursion logic');
 System.assert(OSRUtil.run2Once(), 'Recursion check failed. Please review OSRUtil recursion logic');
 System.assert(!OSRUtil.run2Once(), 'Recursion check failed. Please review OSRUtil recursion logic');
 System.assert(OSRUtil.run3Once(), 'Recursion check failed. Please review OSRUtil recursion logic');
 System.assert(!OSRUtil.run3Once(), 'Recursion check failed. Please review OSRUtil recursion logic');
 
 }
}