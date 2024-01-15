import random

def generate_lists(N):
    list1 = [random.choice([0, 1]) for _ in range(N)]
    list2 = [0 if val1 == 1 else random.choice([0, 1]) for val1 in list1]

    return list1, list2

# Example usage:
N = 64
list1, list2 = generate_lists(N)

print("List 1:", list1)
print("List 2:", list2)