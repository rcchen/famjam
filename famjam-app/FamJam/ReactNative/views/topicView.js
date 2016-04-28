'use strict';

import codePush from "react-native-code-push";

import React, {
  CameraRoll,
  DeviceEventEmitter,
  ScrollView,
  Text,
  TextInput,
  TouchableWithoutFeedback,
  View
} from 'react-native';

var ImagePickerManager = require('NativeModules').ImagePickerManager;
var RNUploader = require('NativeModules').RNUploader;

var Progress = require('react-native-progress');

import { BASE_URL, fetchSignedUploadUrl, fetchTopic } from "../app/services";
import { GridSquare } from "../components/gridSquare";
import { LetterCircle } from "../components/letterCircle";

var styles = React.StyleSheet.create({
  keyboardShift: {
    bottom: 150
  },
  container: {
    flex: 1,
    backgroundColor: '#ECEFF1',
    paddingBottom: 60,
    paddingTop: 20
  },
  name: {
    fontSize: 20,
    fontWeight: "600",
    marginVertical: 10,
    textAlign: "center"
  },
  loading: {
    alignItems: 'center',
    flexDirection: 'row',
    height: 300
  },
  participants: {
    alignItems: "center",
    flexDirection: "row"
  },
  gridView: {
    flexDirection: "row",
    flexWrap: "wrap"
  },
  button: {
    backgroundColor: "#0091EA",
    color: "#FFFFFF",
    paddingHorizontal: 10,
    paddingVertical: 10,
    textAlign: "center"
  },
  addPhotoElement: {
    margin: 5
  },
  scrollView: {
    padding: 5
  },
  textInput: {
    textAlign: "center",
    height: 40,
    borderColor: "#0091EA",
    borderWidth: 1
  },
  progressBar: {
    alignItems: "center",
    marginTop: 10
  }
});

export default class TopicView extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      currentUser: null,
      description: null,
      isUploading: false,
      progress: 0,
      topic: null,
      uploadProgress: 0,
      uploadUrl: null,
      users: []
    };
  }

  render() {
    if (this.state.topic) {
      const colors = ["#F44336", "#2196F3", "#009688", "#FF5722", "#388E3C"];
      const topic = this.state.topic;
      const images = topic.images;

      const users = {};
      topic.users.forEach((user) => {
        users[user._id] = user;
      });
      users[topic._creator._id] = topic._creator;

      const submittedUserIds = Object.keys(users).filter((userId) => {
        return images.some((image) => image._creator == userId);
      });

      const hidden = images.length !== Object.keys(users).length;
      const gridSquares = Object.keys(users).map((userId, index) => {
        let color = "#78909C";
        let image = null;
        if (submittedUserIds.indexOf(userId) > -1) {
          color = colors[index % colors.length];
          image = images.find((image) => image._creator === userId);
        }

        let description = image ? image.description : "Still has to submit!";
        let imageUri = image ? image.url : null;
        let username = users[userId].username;

        return (
          <GridSquare
            color={color}
            description={description}
            hidden={hidden}
            imageUri={imageUri}
            key={userId}
            username={username}
          />
        );
      });

      const uploadingElement = this.state.isUploading ?
        <View style={styles.progressBar}>
          <Progress.Bar progress={this.state.uploadProgress} width={350} />
        </View> : null;

      const userSubmittedImage = submittedUserIds.indexOf(this.state.currentUser._id) > -1;
      const addPhotoElement = userSubmittedImage ? null :
        (
          <View style={styles.addPhotoElement}>
            <TextInput
              autoCapitalize="none"
              autoCorrect={false}
              placeholder="Enter a description here!"
              style={styles.textInput}
              onFocus={() => this.setState({ keyboardOpen: true })}
              onEndEditing={() => this.setState({ keyboardOpen: false })}
              onChangeText={(description) => this.setState({description})}
              value={this.state.description}
            />
            <TouchableWithoutFeedback onPress={this.selectPhoto}>
              <Text style={styles.button}>Upload</Text>
            </TouchableWithoutFeedback>
            { uploadingElement }
          </View>
        );

      return (
        <View style={[styles.container, this.state.keyboardOpen && styles.keyboardShift]}>
          <ScrollView style={styles.scrollView}>
            <Text style={styles.name}>{topic.name}</Text>
            <View style={styles.gridView}>
              { gridSquares }
            </View>
            { addPhotoElement }
          </ScrollView>
        </View>
      );
    } else {
      return (
        <View style={styles.container}>
          <TouchableWithoutFeedback onPress={this.setTopic}>
            <Text>Loading...</Text>
          </TouchableWithoutFeedback>
          <View style={styles.loading}>
            <Progress.CircleSnail
              size={300}
              style={styles.progress}
              thickness={20}
            />
          </View>
        </View>
      )
    }
  }

  componentDidMount() {
    codePush.sync();
    this.attachListeners();
    this.setTopic();
  }

  attachListeners = () => {
    // upload progress
    DeviceEventEmitter.addListener('RNUploaderProgress', (data)=>{
      let bytesWritten = data.totalBytesWritten;
      let bytesTotal   = data.totalBytesExpectedToWrite;
      let progress     = data.progress;

      this.setState({ uploadProgress: bytesWritten / bytesTotal });

      console.log( "upload progress: " + progress + "%");
    });
  }

  increment = () => {
    this.setState({
      progress: this.state.progress + 0.1
    });
  }

  setTopic = () => {
    fetchTopic(this.props.id, this.props.token)
      .then((resp) => {
        this.setState({
          currentUser: resp.user,
          topic: resp.topic
        });
      })
      .catch((error) => {
        console.log(error);
      });
  }

  selectPhoto = () => {
    const options = {
      title: 'Photo Picker',
      takePhotoButtonTitle: 'Take Photo...',
      chooseFromLibraryButtonTitle: 'Choose from Library...',
      quality: 0.5,
      maxWidth: 300,
      maxHeight: 300,
      storageOptions: {
        skipBackup: true
      },
      allowsEditing: true
    };

    ImagePickerManager.showImagePicker(options, (response) => {
      if (response.didCancel) {
        console.log('User cancelled image picker');
      }
      else if (response.error) {
        console.log('ImagePickerManager Error: ', response.error);
      }
      else if (response.customButton) {
        console.log('User tapped custom button: ', response.customButton);
      }

      else {
        this.uploadPhoto(response);
      }
    });
  };

  uploadPhoto = (response) => {
    this.setState({ isUploading: true });
    const files = [
      {
        name: "photo",
        filename: "image.jpg",
        filepath: response.origURL,
        filetype: "image/jpeg"
      }
    ];
    const options = {
      url: BASE_URL + "/topics/" + this.props.id,
      files: files,
      method: "POST",
      headers: {
        "Authorization": "Bearer " + this.props.token
      },
      params: {
        "description": this.state.description
      }
    }

    RNUploader.upload(options, (err, response) => {
        if( err ){
            console.log(err);
            return;
        }

        console.log(response);

        let status = response.status;
        this.setState({ isUploading: false });

        console.log('upload complete with status ' + status);
        this.setTopic();
    });
  };
}
