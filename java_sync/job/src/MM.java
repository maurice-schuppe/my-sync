public class MM {
	int i = 12;
	static int si = 23;
	MO mo = new MO("mo");
	static MO mmo = new MO("mmo");

	public MM() {
		// ff();
		ff(2);
	}

	/* protected */private void ff() {
		System.out.println("MM: ff()");
	}

	public void ff(int i) {
		System.out.println("MM: " + i);
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		MM m = new MM();
		System.out.println(m.i);
		System.out.println(MM.si);
		System.out.println(m.mo);
		System.out.println(MM.mmo);
	}

}
