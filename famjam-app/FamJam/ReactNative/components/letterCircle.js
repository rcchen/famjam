'use strict';

import React, {
  StyleSheet,
  Text,
  View
} from 'react-native';

export class LetterCircle extends React.Component {
  render() {
    const propStyles = StyleSheet.create({
      circle: {
        backgroundColor: this.props.backgroundColor
      },
      text: {
        backgroundColor: this.props.backgroundColor,
        color: this.props.color
      }
    })

    let circleStyle = [styles.circle, propStyles.circle];
    let textStyle = [styles.text, propStyles.text]

    return (
      <View style={styles.wrapper}>
        <View style={circleStyle} />
        <Text style={textStyle}>{this.props.label.toUpperCase()[0]}</Text>
      </View>
    );
  }
}

var styles = React.StyleSheet.create({
  wrapper: {
    height: 50,
    marginHorizontal: 5,
    width: 50
  },
  circle: {
    borderRadius: 25,
    height: 50,
    width: 50
  },
  text: {
    fontSize: 22,
    position: "absolute",
    top: 12,
    left: 19
  }
});
