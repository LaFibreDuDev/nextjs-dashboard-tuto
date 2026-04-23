// Exemple de type générique dans une fonction TypeScript
function presentPerson<T>(arg: T): T {
  if (typeof arg === "string") {
    console.log(`Bonjour, ${arg.toUpperCase()}!`);
  } else if (
    typeof arg === "object" &&
    arg !== null &&
    arg.hasOwnProperty("name")
  ) {
    console.log(`Bonjour, ${arg.name.toUpperCase()}!`);
  }
  return arg;
}

// Appel de la fonction avec une chaîne de caractères
presentPerson("Alice");

// Appel de la fonction avec un objet
presentPerson({ name: "Bob", age: 30 });
