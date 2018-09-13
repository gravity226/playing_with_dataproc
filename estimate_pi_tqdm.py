import random
from tqdm import tqdm

from pyspark import SparkContext

NUM_SAMPLES = 1000

def inside(p):
    for n in tqdm(range(1000)):
        x, y = random.random(), random.random()
    return x*x + y*y < 1

sc = SparkContext()
count = sc.parallelize(c=range(0, NUM_SAMPLES)).filter(inside).count()
print ("Pi is roughly %f" % (4.0 * count / NUM_SAMPLES))
