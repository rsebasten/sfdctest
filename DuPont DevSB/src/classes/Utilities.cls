public class Utilities 
{
    //utility function used to return the first value of the picklist
    //as a number
    public static double returnScore (String pickVal)
    {
        if (pickVal == null)
        {
            return 0;
        } 
        return Double.valueOf(pickVal.substring(0,1)); 
    } 

    static testMethod void runPositiveTestCases() {

        
        Utilities.returnScore (null);
        Utilities.returnScore ('100');

              
}




}