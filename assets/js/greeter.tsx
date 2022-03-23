interface GreeterProps {
  name: string;
}import React from "react";
interface GreeterProps {
    name: string;
}
const Greeter: React.FC<GreeterProps> = (props: GreeterProps) => {
    const name = props.name;
    return (
        <section className="phx-hero">
          <h3>Welcome to {name} with TypeScript and React!</h3>
          <p>Peace-of-mind from prototype to production</p>
        </section>
    );
};
export default Greeter;
