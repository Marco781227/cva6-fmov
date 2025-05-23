#include <stdint.h>
#include <stdio.h>

int main() {
	uint32_t result = 0;
	// Insérer l'instruction FMOV<con> avec une constante, via du code assembleur inline.
	__asm__ __volatile__ (".word 0xXXXXXXXX\n");
	// Récupérer le résultat du registre cible (t0 dans cet exemple) dans une variable C
	__asm__ __volatile__("mv %0, t0" : "=r" (result));
	// Optionnel: utilisation du résultat pour vérifier qu'il correspond à la constante attendue
	if (result != 0xDEADBEEF) {
	// Erreur: la valeur déplacée n'est pas celle attendue
		return 1;
	}
	return 0; // succès
}

