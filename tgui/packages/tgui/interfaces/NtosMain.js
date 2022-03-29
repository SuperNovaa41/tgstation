import { useBackend } from '../backend';
import { Button, ColorBox, Section, Table, Box } from '../components';
import { NtosWindow } from '../layouts';

export const NtosMain = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    device_theme,
    programs = [],
    has_light,
    light_on,
    comp_light_color,
    removable_media = [],
    cardholder,
    login = [],
    proposed_login = [],
  } = data;
  return (
    <NtosWindow
      title={device_theme === 'syndicate'
        && 'Syndix Main Menu'
        || 'NtOS Main Menu'}
      theme={device_theme}
      width={400}
      height={500}>
      <NtosWindow.Content scrollable>
        {!!has_light && (
          <Section>
            <Button
              width="144px"
              icon="lightbulb"
              selected={light_on}
              onClick={() => act('PC_toggle_light')}>
              Flashlight: {light_on ? 'ON' : 'OFF'}
            </Button>
            <Button
              ml={1}
              onClick={() => act('PC_light_color')}>
              Color:
              <ColorBox ml={1} color={comp_light_color} />
            </Button>
          </Section>
        )}
        {!!cardholder && (
          <Section
            title="User Login"
            buttons={(
              <Box>
                <Button
                  icon="eject"
                  content="Eject ID"
                  disabled={!proposed_login.IDName}
                  onClick={() => act('PC_Eject_Disk', { name: "ID" })}
                />
                <Button
                  icon="dna"
                  content="Imprint ID"
                  // eslint-disable-next-line max-len
                  disabled={proposed_login.IDName || (proposed_login.IDName === login.IDName)}
                  onClick={() => act('PC_Imprint_ID', { name: "ID" })}
                />
              </Box>
            )}>
            <Table>
              <Table.Row>
                ID Name: {login.IDName} ({proposed_login.IDName})
              </Table.Row>
              <Table.Row>
                Assignment: {login.IDJob} ({proposed_login.IDJob})
              </Table.Row>
            </Table>
          </Section>
        )}
        {!!removable_media.length && (
          <Section title="Media Eject">
            <Table>
              {removable_media.map(device => (
                <Table.Row key={device}>
                  <Table.Cell>
                    <Button
                      fluid
                      color="transparent"
                      icon="eject"
                      content={device}
                      onClick={() => act('PC_Eject_Disk', { name: device })}
                    />
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          </Section>
        )}
        <Section title="Programs">
          <Table>
            {programs.map(program => (
              <Table.Row key={program.name}>
                <Table.Cell>
                  <Button
                    fluid
                    color={program.alert ? 'yellow' : 'transparent'}
                    icon={program.icon}
                    content={program.desc}
                    onClick={() => act('PC_runprogram', {
                      name: program.name,
                    })} />
                </Table.Cell>
                <Table.Cell collapsing width="18px">
                  {!!program.running && (
                    <Button
                      color="transparent"
                      icon="times"
                      tooltip="Close program"
                      tooltipPosition="left"
                      onClick={() => act('PC_killprogram', {
                        name: program.name,
                      })} />
                  )}
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
