# Name: Noah Frew
# Pawprint: njfdyf
# Class: CS4320
# Date: 2/25/2020

import pytest
import System

def test_login(grading_system):
    username = "goggins"
    password = "augurrox"
    grading_system.login(username, password)
    assert grading_system.usr.name == username

def test_password(grading_system):
    username = "goggins"
    password = "augurrox"
    assert grading_system.check_password(username, password)

def test_change_grade(grading_system):
    TAUsername = "cmhbf5"
    TAPassword = "bestTA"

    studentUsername = "hdjsr7"
    course = "software_engineering"
    assignment = "assignment1"
    grade = 98

    grading_system.login(TAUsername, TAPassword)

    grading_system.usr.change_grade(studentUsername, course, assignment, grade)

    grading_system.reload_data()
    assert grading_system.usr.users[studentUsername]['courses'][course][assignment]['grade'] == grade

def test_create_assignment(grading_system):
    TAUsername = "cmhbf5"
    TAPassword = "bestTA"

    newAssignmentName = "assignment8"
    newDueDate = "2/6/20"
    newCourse = "software_engineering"

    grading_system.login(TAUsername, TAPassword)
    grading_system.usr.create_assignment(newAssignmentName, newDueDate, newCourse)
    grading_system.reload_data()
    assert grading_system.usr.all_courses[newCourse]['assignments'][newAssignmentName]['due_date'] == newDueDate

def test_add_student(grading_system):
    professorUsername = "goggins"
    professorPassword = "augurrox"

    studentName = "akend3"
    courseName = "software_engineering"

    grading_system.login(professorUsername, professorPassword)
    grading_system.usr.add_student(studentName, courseName)
    grading_system.reload_data()
    assert courseName in grading_system.usr.users[studentName]['courses']

def test_drop_student(grading_system):
    professorUsername = "goggins"
    professorPassword = "augurrox"

    studentName = "yted91"
    courseName = "software_engineering"

    grading_system.login(professorUsername, professorPassword)
    grading_system.usr.drop_student(studentName, courseName)
    grading_system.reload_data()
    assert courseName not in grading_system.usr.users[studentName]['courses']

def test_submit_assignment(grading_system):
    studentUsername = "akend3"
    studentPassword = "123454321"

    courseName = "comp_sci"
    assignmentName = "assignment2"
    submission = "jfaopeijf"
    submissionDate = "2/8/20"

    grading_system.login(studentUsername, studentPassword)
    grading_system.usr.submit_assignment(courseName, assignmentName, submission, submissionDate)
    grading_system.reload_data()
    assert grading_system.usr.users[studentUsername]['courses'][assignmentName]['submission'] == submission

def test_check_ontime(grading_system):
    studentUsername = "akend3"
    studentPassword = "123454321"
    
    submissionDate = "2/23/20"
    dueDate = "2/2/20"

    from datetime import datetime as dt
    sd = dt.strptime(submissionDate, "%m/%d/%y")
    dd = dt.strptime(dueDate, "%m/%d/%y")

    grading_system.login(studentUsername, studentPassword)
    

    if sd > dd:
        assert not grading_system.usr.check_ontime(submissionDate, dueDate)
    else:
        assert grading_system.usr.check_ontime(submissionDate, dueDate) 

def test_check_grades(grading_system):
    studentUsername = "akend3"
    studentPassword = "123454321"
    courseName = "comp_sci"

    grades = [['assignment1', 99], ['assignment2', 'N/A']]

    grading_system.login(studentUsername, studentPassword)
    assert grading_system.usr.check_grades("comp_sci") == grades

def test_view_assignments(grading_system):
    studentUsername = "akend3"
    studentPassword = "123454321"
    courseName1 = "databases"
    courseName2 = "comp_sci"

    grading_system.login(studentUsername, studentPassword)

    assert grading_system.usr.view_assignments(courseName1) != grading_system.usr.view_assignments(courseName2)

def test_check_correct_username(grading_system):
    usern = "noah"
    passw = "auggurox"
    
    grading_system.login(usern, passw)
    assert greading_system.usr.name == usern

def test_wrong_professor_add(grading_system):
    professorUsername = "goggins"
    professorPassword = "augurrox"

    studentName = "akend3"
    courseName = "cloud_computing"

    grading_system.login(professorUsername, professorPassword)
    grading_system.usr.add_student(studentName, courseName)
    grading_system.reload_data()
    assert courseName in grading_system.usr.users[studentName]['courses']
    
def test_create_assignment_in_wrong_course(grading_system):
    TAUsername = "cmhbf5"
    TAPassword = "bestTA"

    newAssignmentName = "assignment8"
    newDueDate = "2/6/20"
    newCourse = "comp_sci"

    grading_system.login(TAUsername, TAPassword)
    grading_system.usr.create_assignment(newAssignmentName, newDueDate, newCourse)
    grading_system.reload_data()
    assert grading_system.usr.all_courses[newCourse]['assignments'][newAssignmentName]['due_date'] != newDueDate

def test_wrong_password(grading_system):
    username = "goggins"
    password = "augursux"
    assert grading_system.check_password(username, password)

def test_wrong_check_grades(grading_system):
    studentUsername = "akend3"
    studentPassword = "123454321"
    courseName = "databases"

    grades = [['assignment1', 63], ['assignment2', 64]]

    grading_system.login(studentUsername, studentPassword)
    assert grading_system.usr.check_grades("databases") == grades



@pytest.fixture
def grading_system():
    gradingSystem = System.System()
    gradingSystem.load_data()
    return gradingSystem
