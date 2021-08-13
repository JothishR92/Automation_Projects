import os
class Quiz_game:
    def __init__(self):
        pass

    def file_operation(self):
        file_path = os.getcwd() + "\\quiz!.txt"
        value = open(file_path,"a+")
        return value

    def add_question(self):
        ques= input("Add question :")
        open_file = self.file_operation()
        open_file.write("\n")
        open_file.write(ques)
        open_file.close()


    def read_questions(self):
        l = self.file_operation()
        l.seek(0)
        print(l.read())
        l.close()

    def del_question(self):
        pass



if __name__ == '__main__':
    #Quiz_game.main()
    ob= Quiz_game()
    ob.add_question()
    ob.read_questions()
    #ob.file_operation()


