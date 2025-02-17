# Configuración del entorno de desarrollo

## Dependencias

Deben estar instalados: 
- `flex`
- `bison`
- `cmake`

## Instalación `flex`, `bison` (Windows)
Descargar e instalar preferiblemente en `C:\GnuWin32` o cualquier otro directorio que no contenga espacios (por un posible bug existente con `bison`). Los enlaces para la descarga en Windows de las dependencias son:
- [Flex](http://downloads.sourceforge.net/project/gnuwin32/bison/2.4.1/bison-2.4.1-setup.exe?r=http%3A%2F%2Fgnuwin32.sourceforge.net%2Fpackages%2Fbison.htm&ts=1341786261&use_mirror=voxel)
- [Bison](http://sourceforge.net/projects/gnuwin32/files/flex/2.5.4a-1/flex-2.5.4a-1.exe/download)

Luego, es importante añadir al `PATH` la ubicación de instalación de las dependencias (en caso de que haya sido la sugerida, hay que añadir al `PATH` `C:\GnuWin32`).

## Compilación del proyecto

Primero clonar el repositorio:
```bash
git clone https://github.com/Kukki8/CI4721-Criollito.git
cd CI4721-Criollito
```
Luego, crear el directorio `build`:
```bash
mkdir build
```

Compilar el proyecto:
```bash
cd build
cmake ..
make
```

> [!NOTE]  
> En caso de tener instalado Visual Studio, es posible que `cmake` genere una solución (archivo `.sln`) dentro del directorio `build`. Si es el caso, compilar el código usando Visual Studio.


