public class ctrlPageBase {
	public PageBase page {
		GET {
			return PageBase.getInstance();
		}
	}
	public ctrlPageBase() {}
	public ctrlPageBase(Object c) {this();}	 	//allow use as a extension
}