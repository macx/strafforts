import React from 'react';

import withStyles from '@material-ui/core/styles/withStyles';
import classNames from 'classnames';

import Footer from '../views/Components/Footer';
import imgConnectWithStrava from './../assets/img/btn_strava_connectwith_orange.png';
import imgBackground from './../assets/img/main-bg.jpg';
import HeaderLinks from './Components/HeaderLinks';
import GridContainer from './Components/material-kit-react/Grid/GridContainer.jsx';
import GridItem from './Components/material-kit-react/Grid/GridItem.jsx';
import Header from './Components/material-kit-react/Header/Header.jsx';
import Parallax from './Components/material-kit-react/Parallax/Parallax.jsx';
import { container, title } from './Components/material-kit-react/Styles/material-kit-react.jsx';
import SectionDemo from './Components/SectionDemo';
import SectionGurantees from './Components/SectionGurantees';
import SectionIdea from './Components/SectionIdea';
import SectionTeam from './Components/SectionTeam';

const dashboardRoutes = [];

const homepageStyle = {
  container: {
    zIndex: '12',
    color: '#FFFFFF',
    ...container,
  },
  title: {
    ...title,
    display: 'inline-block',
    position: 'relative',
    marginTop: '30px',
    minHeight: '32px',
    color: '#FFFFFF',
    textDecoration: 'none',
  },
  subtitle: {
    fontSize: '1.313rem',
    maxWidth: '500px',
    margin: '10px auto 0',
  },
  main: {
    background: '#FFFFFF',
    position: 'relative',
    zIndex: '3',
  },
  mainRaised: {
    margin: '-60px 30px 0px',
    borderRadius: '6px',
    boxShadow:
      '0 16px 24px 2px rgba(0, 0, 0, 0.14), 0 6px 30px 5px rgba(0, 0, 0, 0.12), 0 8px 10px -5px rgba(0, 0, 0, 0.2)',
  },
};

class Homepage extends React.Component {
  render() {
    const { classes, ...rest } = this.props;
    return (
      <div>
        <Header
          color="transparent"
          routes={dashboardRoutes}
          brand="STRAFFORTS"
          rightLinks={<HeaderLinks />}
          fixed
          changeColorOnScroll={{
            height: 200,
            color: 'white',
          }}
          {...rest}
        />
        <Parallax filter image={imgBackground}>
          <div className={classes.container}>
            <GridContainer>
              <GridItem xs={12} sm={12} md={6}>
                <h1 className={classes.title}>Analyse Your Strava Running Best Efforts, PBs/PRs and Races</h1>
                <h4>Love Strava? Wanna dig deeper?</h4>
                <h4>
                  Strafforts is an analytics app to visualize your running best efforts, PBs/PRs or races and help you
                  better understand your performance.
                </h4>
                <br />
                <a
                  href="https://www.strava.com/oauth/authorize?client_id=6414&amp;response_type=code&amp;redirect_uri=https://www.strafforts.com:443/auth/exchange-token&amp;approval_prompt=auto&amp;scope=view_private"
                  title="Connect With Strava"
                >
                  <img alt="Connect With Strava" src={imgConnectWithStrava} />
                </a>
              </GridItem>
            </GridContainer>
          </div>
        </Parallax>
        <div className={classNames(classes.main, classes.mainRaised)}>
          <div className={classes.container}>
            <SectionIdea />
            <SectionDemo />
            <SectionGurantees />
            <SectionTeam />
          </div>
        </div>
        <Footer />
      </div>
    );
  }
}

export default withStyles(homepageStyle)(Homepage);
