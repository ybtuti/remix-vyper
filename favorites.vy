# pragma version 0.4.0
# @license MIT

# favourite things list:
# favourite numbers
# favourite people with their favourite numbers
struct Person:
    favourite_number: uint256
    name: String[100]

my_name: public(String[100])
my_favourite_number: public(uint256)

list_of_numbers: public(uint256[5])
list_of_people: public(Person[5])
index: public(uint256)

name_to_favorite_number: public( HashMap[String[100], uint256] )

@deploy
def __init__():
    self.my_favourite_number = 7
    self.index = 0
    self.my_name = "Patrick!!"

@external
def store(new_number: uint256):
    self.my_favourite_number = new_number

@external
@view
def retrieve() -> uint256:
    return self.my_favourite_number


@external
def add_person(name: String[100], favourite_number: uint256):
    # add favourite number to the numbers list
    self.list_of_numbers[self.index] = favourite_number 

    # Add the person to the person's list
    new_person: Person = Person(favourite_number = favourite_number, name = name)
    self.list_of_people[self.index] = new_person

    # Add the person to the hashmap
    self.name_to_favorite_number[name] = favourite_number


    self.index = self.index + 1