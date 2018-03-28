public class ShapeLayerBatchPage 
{
    public ShapeLayerBatchPage()
    {
        
    }
    
    public void RunUserBatch()
    {
        Database.executeBatch(new MACreateShapeLayersByUserBatchable(), 25);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Generate Shape Layers (by User) batch has been started. You will be emailed when finished.'));
    }
    
    public void RunAccountBatch()
    {
        Database.executeBatch(new MACreateShapeLayersByAccountBatchable(), 25);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Generate Shape Layers (by Account) batch has been started. You will be emailed when finished.'));
    }
    
    public void RunContactBatch()
    {
        Database.executeBatch(new MACreateShapeLayersByContactBatchable(), 25);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Generate Shape Layers (by Contact) batch has been started. You will be emailed when finished.'));
    }    
}