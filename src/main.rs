use yew::prelude::*;

#[function_component(App)]
fn app() -> Html {
    html! {
        <h1 style="color:red;">{ "Hello World" }</h1>
        // <h1>{ "Hello World" }</h1>
    }
}

fn main() {
    yew::Renderer::<App>::new().render();
}
