const formDados = document.getElementById('dados-form')
const dadosIniciais = new URLSearchParams( new FormData(formDados)).toString()

formDados.addEventListener('submit', async event => {
    event.preventDefault();

    const formData = new FormData(formDados)
    const dadosAtuais = new URLSearchParams(formData).toString()

    if (dadosAtuais !== dadosIniciais){
        const response = await fetch(
            window.location.pathname,
            {
                method:'POST',
                headers: {'encoding': 'utf-8'},
                body: formData
            }
        )

        if (response.ok){
            alert('Dados alterados com sucesso')
            window.location.reload()
        }
        else{
            const json = await response.json()
            alert(`ERRO\n${json['message']}\n${json['erros']?.join('\n')}`)
        }
    }
})

const formSenha = document.getElementById('senha-form')
formSenha.addEventListener('submit',async event => {
    event.preventDefault()

    const formData = new FormData(formSenha)
    if (formData.get('nova_senha') !== formData.get('confirmar_nova_senha')){
        alert('ERRO\nSenhas são diferentes')
    }
    else{
        const response = await fetch(
            window.location.pathname,
            {
                method:'POST',
                body: formData
            }
        )

        if (response.ok){
            alert('Senha alterada com sucesso')
            window.location.reload()
        }
        else{
            const json = await response.json()
            alert(`ERRO\n${json['message']}\n${json['erros']?.join('\n')}`)
        }
    }
})