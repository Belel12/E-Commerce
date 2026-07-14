const form = document.getElementsByClassName('login')[0]
const botao = document.getElementsByClassName('form-button')[0]
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
    const json = await response.json()
    if (response.ok){
        window.location.href = `${origin}/?id_usuario=${json['user_id']}`
    }
    else{
        alert(`ERRO\n${json['message']}`)
    }
})