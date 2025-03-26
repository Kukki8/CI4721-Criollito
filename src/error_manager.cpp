#include "error_manager.h"
#include <iostream>

std::queue<std::string> errors;

void addError(const std::string& errorMessage) {
    errors.push(errorMessage);
}

void printErrors() {
    while (!errors.empty()) {
        std::cerr << errors.front() << std::endl;
        errors.pop();
    }
}

bool hasErrors() {
    return !errors.empty();
}

