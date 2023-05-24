# parallel-programming-mutex-implementations

### Mutex Implementations

The mutexes are wrapped around the program's lowest-level functionality, so the threads' locking and unlocking are done only when needed. In this case, it's only necessary to lock and unlock when the `stack pointer is adjusted.`

Pop() function
```c++
int Pop()

{

// if the stack is empty, give the Push( ) function a chance to put something on the stack:

int t = 0;

while (StackPtr < 0 && t < TIMEOUT)

t++;

  

// if there is nothing to pop, return;

if (StackPtr < 0)

return FAILED;

if (USE_MUTEX)

	omp_set_lock(&Lock);

int n = Stack[StackPtr];

StackPtr--;

  

WasPopped[n] = true;

if (USE_MUTEX)

	omp_unset_lock(&Lock);

return n;

}
```

Push() function
```c++
void Push(int n)

{

if (USE_MUTEX)

	omp_set_lock(&Lock);

StackPtr++;

Stack[StackPtr] = n;

if (USE_MUTEX)

	omp_unset_lock(&Lock);

}
```

### NUMN values with mutexes in use

For various NUMN values with mutexes in use, there is 0% failure. When a mutex is used to protect access to a shared data structure it ensures that only one thread can access the data at a time which is why there are no failures. This shows that no race conditions occurred.

#### Results:
NUMN =   1024, Failure =  0.00% 
NUMN =   1024, Failure =  0.00% 
NUMN =   1024, Failure =  0.00% 
NUMN =   1024, Failure =  0.00% 
NUMN =   2048, Failure =  0.00% 
NUMN =   2048, Failure =  0.00% 
NUMN =   2048, Failure =  0.00% 
NUMN =   2048, Failure =  0.00% 
NUMN =   4096, Failure =  0.00% 
NUMN =   4096, Failure =  0.00% 
NUMN =   4096, Failure =  0.00% 
NUMN =   4096, Failure =  0.00% 
NUMN =   8192, Failure =  0.00% 
NUMN =   8192, Failure =  0.00% 
NUMN =   8192, Failure =  0.00% 
NUMN =   8192, Failure =  0.00% 
NUMN =  16384, Failure =  0.00% 
NUMN =  16384, Failure =  0.00% 
NUMN =  16384, Failure =  0.00% 
NUMN =  16384, Failure =  0.00% 
NUMN =  32768, Failure =  0.00% 
NUMN =  32768, Failure =  0.00% 
NUMN =  32768, Failure =  0.00% 
NUMN =  32768, Failure =  0.00%


### NUMN values with mutexes not in use

When there is no mutex used this allows multiple threads to access the data simultaneously, this can lead to a race condition which can cause unpredictable behavior. This causes errors to occur because the stack pointer is now mismatching among the locations and not locked onto a specific thread. This is shown clearly by the high failure rate in the results.

#### Results:
NUMN =   1024, Failure =  0.00% 
NUMN =   1024, Failure =  0.00% 
NUMN =   1024, Failure =  0.00% 
NUMN =   1024, Failure = 19.24% 
NUMN =   2048, Failure =  0.00% 
NUMN =   2048, Failure =  0.00% 
NUMN =   2048, Failure =  0.00% 
NUMN =   2048, Failure = 26.56% 
NUMN =   4096, Failure =  0.00% 
NUMN =   4096, Failure = 13.38% 
NUMN =   4096, Failure = 35.94% 
NUMN =   4096, Failure =  0.00% 
NUMN =   8192, Failure =  0.00% 
NUMN =   8192, Failure = 51.55% 
NUMN =   8192, Failure = 49.33% 
NUMN =   8192, Failure = 36.62% 
NUMN =  16384, Failure = 53.03% 
NUMN =  16384, Failure = 36.13% 
NUMN =  16384, Failure = 43.68% 
NUMN =  16384, Failure = 34.20% 
NUMN =  32768, Failure = 43.84% 
NUMN =  32768, Failure = 47.34% 
NUMN =  32768, Failure = 48.07% 
NUMN =  32768, Failure = 36.31% 

### Commentary

1. Machine used: `Apple Intel: 2.3 GHz dual-core`
2. Operating system used: `MacOS Ventura`
3. Compiler used: `clang++`
4. Code `included above` where mutexes were used (pop() and push() functions when stack pointer is adjusted)
5.  Discoveries:
	1. Does the non-mutex way of doing this work and if so how often?
		- Occasionally, the non-mutex way of doing this does work, however, it is not guaranteed and we can easily see this in the results. 
	2. Does changing the NUMN make any difference in the failure percentage?
		- Changing the NUMN does affect the failure percentage, it looks like as NUMN is reduced the failure percentage is also reduced. This could be because when threads access a shared data structure the probability of race conditions increases as the number of access increases. 
	3. Elapsed execution time between mutex and non-mutex? Why?
		- In the case of this experiment with only two threads it looks like using a mutex to lock access when changing the pointer value increases the time elapsed. The times have a smaller range in the mutex-enabled trials but in the non-mutex trials there are some extremely fast times with 0 error, however, this is non-deterministic and won't be useful in many cases.
		- This shows us that there is a performance impact of using a mutex which can be influenced by mutex design/hardware, number of threads accessing the shared data structure, size of the data structure, and perhaps where the mutex is implemented within the program.
