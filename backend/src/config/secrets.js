const requiredSecret = (name, minimumLength = 1) => {
    const value = process.env[name];
    if (!value || value.trim().length < minimumLength) {
        throw new Error(`A variável de ambiente ${name} é obrigatória e precisa ter ao menos ${minimumLength} caracteres.`);
    }
    return value;
};

module.exports = { requiredSecret };
