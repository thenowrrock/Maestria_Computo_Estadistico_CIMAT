#include <cstdio>
#include <cstdlib>


__global__ void reverse_vect(int *arr, int siz){

	extern __shared__ int s[];
	int t = threadIdx.x;
	int tr = siz-t-1;

	s[t] = arr[t];
	__syncthreads();
	arr[t]=s[tr];

}


int main(){
	int n=10; 
	int *arr,*darr;
	arr = new int [n];
	cudaMalloc((void**) &darr,n*sizeof(int));
	for(int i=0;i<n;i++){
		arr[i] = rand()%10;
		printf("%d\t",arr[i]);
	}
	printf("\n");
	cudaMemcpy(darr,arr,n*sizeof(int),cudaMemcpyHostToDevice);

	reverse_vect<<<1,n,n*sizeof(int)>>>(darr,n);

	cudaMemcpy(arr,darr,n*sizeof(int),cudaMemcpyDeviceToHost);
	for(int i=0;i<n;i++){
		printf("%d \t ", arr[i]);
	}
	printf("\n");

	delete arr;
	cudaFree(darr);
	return 0;
}
