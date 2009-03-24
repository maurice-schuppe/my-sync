package luke.android.utils.algorithms.sort;

public class QuickSort2 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		int[] datas = { 1, 21, 34, 79, 98, 23, 68, 2, 3, 8, 6, 33, 6, 7, 87,
				32, 24, 6, 776 };
		QuickSort2 quickSort = new QuickSort2();
		datas = quickSort.sort(datas);
		for (int i = 0; i < datas.length; i++) {
			System.out.print(datas[i] + " ");
		}
	}

	public int[] sort(int[] data) {
		quickSort(data, 0, data.length - 1);
		return data;
	}

	void quickSort(int[] pData, int left, int right) {
		int i, j;
		int iTemp;
		int middle;
		i = left;
		j = right;
		middle = pData[(left + right) / 2];
		do {
			System.out.println(i + ", " + j);
			while ((pData[i] < middle) && (i < right))
				i++;
			while ((pData[j] > middle) && (j > left))
				j--;
			if (i <= j) {
				iTemp = pData[i];
				pData[i] = pData[j];
				pData[j] = iTemp;
				i++;
				j--;
			}

		} while (i <= j);// �������ɨ����±꽻������ֹͣ�����һ�Σ�

		if (left < j)
			quickSort(pData, left, j);
		if (right > i)
			quickSort(pData, i, right);
	}

}