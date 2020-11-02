#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <mpi.h>

double GetTime() {
  timespec t;
  clock_gettime(CLOCK_MONOTONIC, &t);
  return t.tv_sec + t.tv_nsec / 1e9;
}

int main(int argc, char **argv) {
  MPI_Init(&argc, &argv);
  const int ITER = 10;
  int rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  size_t sz = 1L * 1024 * 1024 * 1024; // 1GB
  void *buf = malloc(sz);
  double st, et;
  if (rank == 0) {
    for (int i = 0; i < ITER; ++i) {
      st = GetTime();
      MPI_Send(buf, sz, MPI_CHAR, 1, 0, MPI_COMM_WORLD);
      et = GetTime();
      printf("[rank %d] %f GB/s\n", rank, sz / 1e9 / (et - st));
    }
  } else {
    for (int i = 0; i < ITER; ++i) {
      st = GetTime();
      MPI_Recv(buf, sz, MPI_CHAR, 0, 0, MPI_COMM_WORLD, NULL);
      et = GetTime();
      printf("[rank %d] %f GB/s\n", rank, sz / 1e9 / (et - st));
    }
  }
  MPI_Finalize();
  return 0;
}
