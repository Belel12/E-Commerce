import {newForm,newHiddenInput} from "./element_factory.js";

window.comprarAdicionarCarrinho = function(id_usuario, id_produto, acao) {
    const message = (acao === 'comprar')? 'Confirme a compra do produto' : 'Deseja adicionar este item ao carrinho?'
    if(!confirm(message)){return}
    const input_quantidade = document.getElementById('quantidade').cloneNode(true)
    if(input_quantidade.value > input_quantidade.getAttribute('max')){
        alert('Quantidade indisponível no estoque');
        return;
    }
    if(input_quantidade.value < 0){
        alert('Quantidade inválida');
        return;
    }

    const input_id_produto = newHiddenInput('id_produto',id_produto)

    const input_id_usuario = newHiddenInput('id_usuario',id_usuario)

    const form = newForm(
        (acao === 'carrinho')? '/adicionar_carrinho' : '/comprar',
        [input_id_usuario,input_id_produto,input_quantidade]
    )

    document.body.appendChild(form)
    form.submit()
}