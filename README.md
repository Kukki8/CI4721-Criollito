# Criollito
## Tipos Primitivos

- Caracteres (Beta): Alfanuméricos.
- Booleanos (Calidad): `chévere` y `chimbo`
- Enteros (Lucas): Números
- Flotantes (Sencillo): 1.15

## Tipos Compuestos
- Arreglos (Bululú): [ a, s, d, f ], `tipo nombre[tamaño], lucas nombre[] = [1, 2, 3]`
- String (Labia): “asfda”
- Registros (Saime): `saime nombre { tipo valor }`
- Variantes (Pastelero): `pastelero nombre { lucas: lucas }`
- Apuntador (Guachimán): `👉a`

## Palabras reservadas
### Mecanismos de selección
If: porsia, else: cónchale
```
Ej.
porsia (asdfa = asdf) {
	cuerpo
} conchale {
	cuerpo
}
```

### Mecanismos de repetición
For: 
```
para a en bululú {}

para a de lucas a lucas {}

Ej:
lucas a[3] = [1, 2, 3];
para x en a {}
para x de 0 a 5 {}
```
While:
```
mientras (condicion) echale pichon {}

Ej:
mientras (x < 3) echale pichon {paralo}
```
Break: Paralo
### Subrutinas
```
tipo chamba (tipo a) {
	cuerpo
	fuimonos vaina<tipo>;
}

Ej. pasaje de parámetros por valor (por defecto):
lucas chamba (lucas a) {
	a = a + 1;
	fuimonos a;
}

Ej. pasaje de parámetros por referencia:

saime gente {
	lucas bolivitas;
}
lucas chamba valorDelBono(gente👉 persona) {
	fuimonos persona.bolivitas;
}
```
**Return: `fuimonos`**

# Otros
Algunas cosas generales definidas dentro del lenguaje:
- Secuenciación: `;`
- Par ordenado (Cuadre): `(a, b)`
- Error: Guácala
- Print: Dígalo
- Input: Rotalo
- Main (como en C): `vacio chisme() { fuimonos; }`

# Programas
## Hola mundo
```
vacio chisme() {
	digalo("Hola mundo");
	fuimonos;
}
```

## Hola usuario
```
vacio chisme() {
	digalo("Ingresa tu nombre");
	labia nombre = rotalo;
	digalo(nombre);
	fuimonos;
}
```

## Sumar números
Sumar todos los números de la entrada hasta que se ingrese cero (0)
```
vacio chisme() {
	lucas res = 0;
	mientras (chevere) echale pichon {
		lucas numero = rotalo;
		porsia (numero == 0) {
			paralo;
		} conchale {
			res = res + numero;
		}
	}
	digalo(res);
	fuimonos;
}
```

## Fibonacci
```
lucas chamba nthFibonacci(lucas n) {
	porsia (n <= 1) {
		fuimonos n;
	}
	fuimonos nthFibonacci(n-1) + nthFibonacci(n-2);
}
vacio chisme() {
	lucas n = rotalo;
	lucas res = nthFibonacci(n);
	fuimonos res;
}
```

## Multiplicación de matrices
```
lucas[][] mulMat(lucas👉 a[][], lucas👉 b[][]) {
	lucas r1 = a.sais();
	lucas c1 = a[0].sais();
	lucas r2 = b.sais();
	lucas c2 = b[0].sais();
	
	porsia (c1 != r2) {
		digalo("Invalid input");
		fuimonos -1;
	}

	lucas res[r1][c2];
	lucas i = 0;
	lucas j = 0;
	lucas k = 0;

	mientras (i < r1) echale pichon {
		mientras (j < c2) echale pichon {
			res[i][j] = 0;
			
			mientras (k < c1) echale pichon {
				res[i][j] = res[i][j] + a[i][k] * b[k][j];
				k = k+1;
			}
			j = j+1;
		}
		i = i+1;
	}

	fuimonos res;
}

vacio chisme() {
	fuimonos;
}
```
