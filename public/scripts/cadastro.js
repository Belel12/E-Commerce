const form = document.getElementsByClassName('cadastro')[0]
const botao = document.getElementsByClassName('form_button')[0]
const origin = window.location.origin
botao.addEventListener('click', async () => {
    if (!form.checkValidity()){
        form.reportValidity()
        return
    }
    const formData = new FormData(form)
    const response = await fetch(form.action, {
        method: 'POST',
        body: formData
    })
    if (response.ok){
        alert('Usuário cadastrado com sucesso')
        window.location.href = `${origin}/login`
    }
    else{
        const json = await response.json()
        alert(`ERRO\n${json['message']}`)
    }
})