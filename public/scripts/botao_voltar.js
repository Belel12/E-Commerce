//qualquer botão com class="go-back-button" será escutado ao ser clicado
//fazendo a tela retornar à url que está em seu atributo id

const botoes = document.getElementsByClassName('go-back-button')

for(let botao of botoes){
    botao.addEventListener('click',() => {
        window.location.href = botao.getAttribute('id');
    })
}
