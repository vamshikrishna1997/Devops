def isdiv2(number):

 a = int(number[-1])

 if a in [0,2,4,6,8]:
     return True
 else:
     return False


if __name__ == "__main__":
    number = input("Enter a number:")
    print(f"{number} is {'' if isdiv2(number) else 'not'} divisble by 2")









