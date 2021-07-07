# iOS Calculator App (with Objective C Framework)

## Project Summary
The app features a calculator developed in Swift with arithmetic logic written as an Objective C Framework.

<p float="left">
 <img width="282" alt="portrait_calc" src="https://user-images.githubusercontent.com/45325370/124705831-e2305100-debb-11eb-8284-2169b7cb4513.png"/>
 <img width="575" alt="landscape_calc" src="https://user-images.githubusercontent.com/45325370/124705846-e8263200-debb-11eb-9161-b2f8a9e20211.png"/>
</p>

## Structure of Project
CalcArithmetic Framework -- used to evaluate mathematical expressions. <br>
Classes within Framework:
  * CoreLogic - provides methods that can be used to simplify and/or solve mathematical expressions.
  * InvalidExpressionHandling - provides methods to test whether a given expression is a valid mathematical expression. Note that only two such methods were implemented thus far, and therefore do not protect against all invalid expressions. Further info is provided in the file's documentation. 

CalcApp -- the iOS app.
User interface developed on Storyboard. PLEASE NOTE: Auto Layout has only been applied to iPhone 11 portrait and landscape mode thus far. <br>
  

## Specifics:
The calculator supports the following functionalities, and any combination of them. <br>
  * Addition
  * Subtraction
  * Multiplication
  * Division
  * Basic trigonometric functions (sine, cosine, tangent)

<br>
