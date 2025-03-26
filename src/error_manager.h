#ifndef ERROR_MANAGER_HPP
#define ERROR_MANAGER_HPP

#include <queue>
#include <string>

extern std::queue<std::string> errors;

void addError(const std::string& errorMessage);
void printErrors();
bool hasErrors();

#endif // ERROR_MANAGER_HPP

