"""
На вход программе подается строка текста, содержащая символы и число n.
Из данной строки формируется список. Напишите программу, которая разделяет список на вложенные подсписки так,
что n последовательных элементов принадлежат разным подспискам.

Формат входных данных
На вход программе подается строка текста, содержащая символы, отделенные символом пробела и число n на отдельной строке.

Формат выходных данных
Программа должна вывести указанный вложенный список.
"""

C = input().split()
n = int(input())


def list_slice(S, step):
    return [S[i::step] for i in range(step)]


print(list_slice(C, n))


"""
Формат входных данных
На вход программе подаётся натуральное число n — количество строк и столбцов в матрице, затем элементы матрицы.

Формат выходных данных
Программа должна вывести одно число — максимальный элемент в заштрихованной области квадратной матрицы.

Примечание. Элементы побочной диагонали также учитываются.
"""
n = int(input())

a = [[int(x) for x in input().split()] for i in range(n)]

s = []
for i in range(n):
    for j in range(n):
        if (i >= j and i >= n - 1 - j) or (i <= j and i >= n - 1 - j):
            s.append(a[i][j])
print(max(s))


"""
Напишите программу, которая транспонирует квадратную матрицу.

Формат входных данных
На вход программе подаётся натуральное число n — количество строк и столбцов в матрице, затем элементы матрицы.

Формат выходных данных
Программа должна вывести транспонированную матрицу.

Примечание 1. Транспонированная матрица — матрица, полученная из исходной матрицы заменой строк на столбцы.

Примечание 2. Задачу можно решить без использования вспомогательного списка.
"""

# Считываем размер матрицы
n = int(input())

# Считываем элементы матрицы
matrix = [list(map(int, input().split())) for _ in range(n)]

# Транспонируем матрицу
transposed_matrix = [[matrix[j][i] for j in range(n)] for i in range(n)]

# Выводим транспонированную матрицу
for row in transposed_matrix:
    print(" ".join(map(str, row)))


"""
На вход программе подается нечетное натуральное число 
n . Напишите программу, которая создает матрицу размером 
𝑛
×
n ×n заполнив её символами . . Затем заполните символами * среднюю строку и столбец матрицы, главную и побочную диагональ матрицы. Выведите полученную матрицу на экран, разделяя элементы пробелами.

Формат входных данных
На вход программе подается нечетное натуральное число 
𝑛
,
(
𝑛
≥
3
)
n,(n≥3) — количество строк и столбцов в матрице.

Формат выходных данных
Программа должна вывести матрицу в соответствии с условием задачи.
"""

n = int(input())

a = [["." for x in range(n)] for i in range(n)]
for i in range(n):
    for j in range(n):
        if i == n // 2 or j == n // 2 or i == n - 1 - j or i == j:
            a[i][j] = "*"
for x in a:
    print(*x)


"""
Напишите программу проверки симметричности квадратной матрицы относительно побочной диагонали.

Формат входных данных
На вход программе подаётся натуральное число 
n — количество строк и столбцов в матрице, затем элементы матрицы.

Формат выходных данных
Программа должна вывести YES, если матрица симметрична, и слово NO в противном случае.
"""

n = int(input())
matrix = [[int(i) for i in input().split()] for _ in range(n)]
flag = "YES"
for i in range(n):
    for j in range(n):
        if matrix[i][j] != matrix[n - j - 1][n - i - 1]:
            flag = "NO"
            break
    if flag == "NO":
        break
print(flag)


"""
Латинским квадратом порядка 
n называется квадратная матрица размером 
𝑛
×
n ×n, каждая строка и каждый столбец которой содержат все числа от 
1
1 до 
n . Напишите программу, которая проверяет, является ли заданная квадратная матрица латинским квадратом.

Формат входных данных
На вход программе подаётся натуральное число 
n — количество строк и столбцов в матрице, затем элементы матрицы: 
n строк, по 
n чисел в каждой, разделённые пробелами.

Формат выходных данных
Программа должна вывести слово YES, если матрица является латинским квадратом, и слово NO, если не является.
"""

n = int(input())
lst = []
for i in range(n):
    temp = [int(num) for num in input().split()]
    lst.append(temp)


def checklatin(latin):

    numbers = set(range(1, len(latin) + 1))

    if any(set(row) != numbers for row in latin) or any(
        set(col) != numbers for col in zip(*latin)
    ):
        print("NO")

    else:
        print("YES")


checklatin(lst)


"""
На шахматной доске 
8
×
8
8×8 стоит ферзь. Отметьте положение ферзя на доске и все клетки, которые бьет ферзь. Клетку, где стоит ферзь, отметьте буквой Q, клетки, которые бьет ферзь, отметьте символами *, остальные клетки заполните точками.

Формат входных данных
На вход программе подаются координаты ферзя на шахматной доске в шахматной нотации (то есть в виде e4, где сначала записывается номер столбца (буква от a до h, слева направо), затем номер строки (цифра от 
1
1 до 
8
8, снизу вверх)).

Формат выходных данных
Программа должна вывести на экран изображение доски, разделяя элементы пробелами.
"""

pos = input()
x = 8 - int(pos[1])
y = "abcdefgh".find(pos[0])
arr = [["."] * 8 for _ in range(8)]
for i in range(8):
    for j in range(8):
        if i == x and j == y:
            arr[i][j] = "Q"
        elif i == x or j == y or abs(i - x) == abs(j - y):
            arr[i][j] = "*"
    print(*arr[i])

"""
На вход программе подается натуральное число 
n . Напишите программу, которая создает матрицу размером 
𝑛
×
n ×n и заполняет её по следующему правилу:

на главной диагонали на месте каждого элемента должно стоять число 
0
0;
на двух диагоналях, прилегающих к главной, – число 
1
1;
на следующих двух диагоналях – число 
2
2, и т.д.
Формат входных данных
На вход программе подается натуральное число 
n  — количество строк и столбцов в матрице.

Формат выходных данных
Программа должна вывести матрицу в соответствии с условием задачи.
"""

n = int(input())
a = [[0 for _ in range(n)] for _ in range(n)]
for i in range(n):
    for j in range(n):
        a[i][j] = abs(j - i)

for i in a:
    print(*i)