#include <stdio.h>
#include <stdlib.h>
#include <math.h>


#define MAXTHREADS 256

__global__ void suma_vect(int *a, int *b, int *c,int n){
	int i= threadIdx.x;
	c[i]=a[i]+b[i];
}

__global__ void suma_vect2(int *a, int *b, int *c,int n){
	int i=blockIdx.x*blockDim.x + threadIdx.x;
	if(i<n){
		c[i] = a[i] + b[i];
	}
}

int main(){
	int *a,*b,*c;
	int *dev_a,*dev_b,*dev_c;
	
	int n=10;

	a=new int[n];
	b=new int[n];
	c=new int[n];

 	cudaError_t cudastatus;

	cudastatus = cudaMalloc((void**) &dev_a, n*sizeof(int));

	if(cudastatus != cudaSuccess){
		printf("Error\n");
		exit(0);
	}
	cudaMalloc((void**) &dev_b,n*sizeof(int));
	cudaMalloc((void**) &dev_c,n*sizeof(int));

	for(int i=0; i<n; i++){
		a[i]=rand()%10;
		b[i]=rand()%10;
	}


	cudastatus = cudaMemcpy(dev_a,a,n*sizeof(int), cudaMemcpyHostToDevice);

	if(cudastatus!=cudaSuccess){
		printf("Error \n");
		exit(0);
	}

	cudastatus = cudaMemcpy(dev_b,b,n*sizeof(int), cudaMemcpyHostToDevice);

	if(cudastatus != cudaSuccess){
		printf("Error\n");
		exit(0);
	}
	//Ejecución del código sobre GPU
int nBlock = (int)ceil((double)n/MAXTHREADS);
	suma_vect<<<nBlock,MAXTHREADS>>>(dev_a,dev_b,dev_c,n);

	cudastatus = cudaMemcpy(c,dev_c,n*sizeof(int),cudaMemcpyDeviceToHost );

	if(cudastatus != cudaSuccess){
		printf("Error\n");
		exit(0);
	}

	for(int i=0;i<n;i++){
		printf("%d \t %d \t %d\n", a[i],b[i],c[i]);
	}

	delete a;
	delete b;
	delete c;
	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);

	return 0;
}
