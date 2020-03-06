import React from "react";
import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";

class App extends React.Component {
  //const [startDate, setStartDate] = useState(new Date());

  constructor(props) {
    super(props);
    this.state = {
      startDate: new Date(),
      email: ""
    };
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleDateChange = date => {
    this.setState({
      startDate: date
    });
  };

  handleEmailChange(event) {
    this.setState({
      email: event.target.value
    });
  }

  handleSubmit(event) {
    event.preventDefault();
    const options = {
      method: "POST",
      mode: "no-cors",
      body: JSON.stringify({
        reservation_email: this.state.email,
        reservation_date: this.state.startDate
      }),
      headers: {
        "Content-Type": "application/json"
      }
    };
    console.log(options);
    console.log(typeof options.body);
    // fetch(process.env.REACT_APP_SUBMIT_URL, options).
    fetch(
      " https://cu36rmy8rb.execute-api.us-east-1.amazonaws.com/prod/shs-it-api",
      options
    );
    // .then(res => res.json())
    // .then(res => console.log(res));
  }

  render() {
    return (
      <div className="App">
        <header className="App-header">
          <p>Book a date for your trip!</p>
        </header>
        Email:{" "}
        <input
          type="text"
          name="email"
          onBlur={this.handleEmailChange.bind(this)}
        />{" "}
        <br />
        Date:{" "}
        <DatePicker
          selected={this.state.startDate}
          onChange={this.handleDateChange}
        />{" "}
        <br />
        <input
          type="button"
          name="submit"
          value="submit"
          onClick={this.handleSubmit}
        />
        <br />
      </div>
    );
  }
}

export default App;
